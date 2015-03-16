package com.listingproduct.swank;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import com.listingproduct.swank.data.Condition;
import com.listingproduct.swank.data.ListingType;
import com.listingproduct.swank.global.GlobalDefine;
import com.listingproduct.swank.global.GlobalFunc;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.Toast;
import android.widget.RadioGroup.OnCheckedChangeListener;

public class MainActivity extends Activity implements OnClickListener,
		OnCheckedChangeListener {

	public Typeface font;
	int mUserId;
	Condition mCondition = Condition.USED;
	ListingType mListingType = ListingType.BIN;
	boolean mNormalSearch;

	EditText keywordEt;
	String Tag = "stSwankFragment";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.activity_main);

		// load Font
		font = Typeface.createFromAsset(getAssets(), "fontawesome-webfont.ttf");

		// Get User ID
		mUserId = 0;

		// Search Keyword
		keywordEt = (EditText) findViewById(R.id.keywordInput);

		Button searchBtn = (Button) findViewById(R.id.searchBtn);
		searchBtn.setTypeface(font);
		searchBtn.setOnClickListener(this);

		// Search Buttons
		Button normalSearch = (Button) findViewById(R.id.normalSearchBtn);
		normalSearch.setTypeface(font);
		normalSearch.setOnClickListener(this);

		Button exactSearch = (Button) findViewById(R.id.exactSearchBtn);
		exactSearch.setTypeface(font);
		exactSearch.setOnClickListener(this);

		SegmentedGroup segmented1 = (SegmentedGroup) findViewById(R.id.segmented1);
		segmented1.setTintColor(getResources().getColor(
				R.color.radiogroup_color));

		SegmentedGroup segmented2 = (SegmentedGroup) findViewById(R.id.segmented2);
		segmented2.setTintColor(getResources().getColor(
				R.color.radiogroup_color));

		segmented1.setOnCheckedChangeListener(this);
		segmented2.setOnCheckedChangeListener(this);

		LinearLayout barcodeScanLL = (LinearLayout) findViewById(R.id.barcodeScanLL);
		barcodeScanLL.setOnClickListener(this);

	}

	@Override
	public void onClick(View v) {
		int viewID = v.getId();
		switch (viewID) {
		case R.id.searchBtn:
			regularSwankCall();
			break;
		case R.id.normalSearchBtn:
			mNormalSearch = true;
			regularSwankCall();
			break;
		case R.id.exactSearchBtn:
			mNormalSearch = false;
			regularSwankCall();
			break;
		case R.id.barcodeScanLL:
			IntentIntegrator integrator = new IntentIntegrator(
					MainActivity.this);
			integrator.initiateScan();
			break;
		default:
			break;
		}
	}

	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		IntentResult scanResult = IntentIntegrator.parseActivityResult(
				requestCode, resultCode, intent);
		if (scanResult != null) {
			keywordEt.setText("");
			String contents = scanResult.getContents();
			String toString = scanResult.toString();
			String formatName = scanResult.getFormatName();

			GlobalFunc.viewLog(Tag, "contents", false);
			GlobalFunc.viewLog(Tag, contents, true);

			GlobalFunc.viewLog(Tag, "all string", false);
			GlobalFunc.viewLog(Tag, toString, true);

			GlobalFunc.viewLog(Tag, "format name", false);
			GlobalFunc.viewLog(Tag, formatName, true);
			// showToast(formatName);
			// handle scan result

			if (contents != null && !contents.isEmpty()) {
				barcodeScanCall(contents, formatName);
			}
		}
	}

	void showToast(String msg) {
		Toast.makeText(this, msg, Toast.LENGTH_LONG).show();
	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		switch (checkedId) {
		case R.id.button11:
			mCondition = Condition.USED;
			return;
		case R.id.button12:
			mCondition = Condition.NEW;
			return;
		case R.id.button13:
			mCondition = Condition.BOTH;
			return;
		case R.id.button21:
			mListingType = ListingType.AUCTION;
			return;
		case R.id.button22:
			mListingType = ListingType.BIN;
			return;
		case R.id.button23:
			mListingType = ListingType.BOTH;
			return;
		}
	}

	private void regularSwankCall() {

		String strQuery = keywordEt.getText().toString();
		strQuery = strQuery.trim();
		if (strQuery.isEmpty()) {
			// If there is no keyword for search, return without processing
			return;
		}

		// condition and listing type
		String conditionUrlElem;
		String listingTypeUrlElem;
		conditionUrlElem = mCondition.getUrlElement();
		listingTypeUrlElem = mListingType.getUrlElement();

		// query part
		String searchQuery = strQuery;
		try {
			searchQuery = URLEncoder.encode(searchQuery, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		if (!mNormalSearch) {
			searchQuery = "@" + searchQuery;
		}

		// Search Query
		searchQuery = String.format("&query=%s", searchQuery);

		// User Id Part
		String userId = String.format("user_id=%d", mUserId);

		// 1:userid, 2:query, 3:condtion, 4:listingtype, 5:barcodetype
		String strSearchUrl = String.format(
				GlobalDefine.SiteURLs.swankSearchURL, userId, searchQuery,
				conditionUrlElem, listingTypeUrlElem, "");
		strSearchUrl = strSearchUrl.trim();
		GlobalFunc.viewLog(Tag, strSearchUrl, true);

		Intent intent = new Intent(MainActivity.this,
				SwankSearchResultActivity.class);
		intent.putExtra("searchUrl", strSearchUrl);
		startActivity(intent);
	}

	private void barcodeScanCall(String codeContent, String codeFormat) {

		codeContent = codeContent.trim();
		codeFormat = codeFormat.trim();

		if (codeContent.isEmpty()) {
			// If there is no barcode for search, return without processing
			showToast("Cannot get barcode number. Please try again.");
			return;
		}

		if (codeFormat.isEmpty()) {
			// If there is no barcode format, return without processing
			showToast("Cannot get barcode format. Please try again.");
			return;
		}

		int nPos = codeFormat.indexOf("_");
		if (nPos != -1) {
			codeFormat = codeFormat.substring(0, nPos);
		}

		// condition and listing type
		String conditionUrlElem;
		String listingTypeUrlElem;
		conditionUrlElem = mCondition.getUrlElement();
		listingTypeUrlElem = mListingType.getUrlElement();

		// User Id Part
		String userId = String.format("user_id=%d", mUserId);
		String searchQuery = String.format("&query=%s", codeContent);
		String barCodeFormat = String.format("&barcodeType=%s", codeFormat);
		
		// 1:userid, 2:query, 3:condtion, 4:listingtype, 5:barcodetype
		String strSearchUrl = String.format(
				GlobalDefine.SiteURLs.swankSearchURL, userId, searchQuery,
				conditionUrlElem, "", barCodeFormat);
		strSearchUrl = strSearchUrl.trim();
		GlobalFunc.viewLog(Tag, strSearchUrl, true);

		Intent intent = new Intent(MainActivity.this,
				SwankSearchResultActivity.class);
		intent.putExtra("searchUrl", strSearchUrl);
		startActivity(intent);
	}
}
