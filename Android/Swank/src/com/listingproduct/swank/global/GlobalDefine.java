package com.listingproduct.swank.global;

public final class GlobalDefine {
	public static final class CommonState {
		public static final boolean debug_mode = true;
	}

	public static final String[] MONTH_Title = { "Jan", "Feb", "Mar", "Apr",
			"May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

	public static final class SiteURLs {
		// Swank Search
		// public static final String swankSearchURL =
		// "http://stoplisting.com/api/?swank%s%s%s%s%s";
		public static final String swankSearchURL = "http://stoplisting.com/api/swank.php?%s%s%s%s%s";
	}
}
