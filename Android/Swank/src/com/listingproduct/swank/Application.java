package com.listingproduct.swank;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;

import android.graphics.Typeface;

public class Application extends android.app.Application {

	// Debugging switch
	public static final boolean APPDEBUG = false;

	// Debugging tag for the application
	public static final String APPTAG = "Swank";

	// for fontawesome icon
	private Typeface font;

	// for Cashing Bitmap
	protected ImageLoader imageLoader;

	@Override
	public void onCreate() {
		super.onCreate();
		// load Font
		font = Typeface.createFromAsset(getAssets(), "fontawesome-webfont.ttf");
		imageLoader = ImageLoader.getInstance();
		imageLoader.init(ImageLoaderConfiguration
				.createDefault(getBaseContext()));
	}

	@Override
	public void onTerminate() {
		imageLoader.clearDiskCache();
		imageLoader.clearMemoryCache();
		super.onTerminate();
	}

	// return fontawesome icon
	public Typeface getFont() {
		return font;
	}

	// return ImageLoader object
	public ImageLoader getImageLoader() {
		return imageLoader;
	}
}