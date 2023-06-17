# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SZBALINT
DIST_VERSION=4.17
inherit perl-module

DESCRIPTION="Perl extension interface for libcurl"

LICENSE="|| ( MPL-1.0 MPL-1.1 MIT )"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

# https://rt.cpan.org/Public/Bug/Display.html?id=145992
SRC_URI+="
	https://rt.cpan.org/Public/Ticket/Attachment/2423633/1093328/WWW-Curl-4.17-Work-around-a-macro-bug-in-curl-7.87.0.patch
	"

PATCHES=(
	"${FILESDIR}"/${PN}-4.150.0-curl-7.50.2.patch
	"${FILESDIR}"/${PN}-4.17-dotinc.patch
	"${FILESDIR}"/${PN}-4.17-networktests.patch
	"${FILESDIR}"/${PN}-4.17-RT117793.patch
	"${FILESDIR}"/${PN}-4.17-RT130591.patch
	"${FILESDIR}"/${PN}-4.17-RT132197.patch
	"${DISTDIR}/WWW-Curl-4.17-Work-around-a-macro-bug-in-curl-7.87.0.patch"
)

src_prepare() {
	perl-module_src_prepare
	# Makefile.PL does some creative things parsing macros vs defines from curl
	# build system
	#
	# However, it tends to be very fragile and needs lots of patching, so
	# instead of multiple patches, make it a variable and hoist it to the
	# ebuild.
	#
	# Use the modifier flags aax means we can write an easier to manage regex as well.
	sed -i -r \
		-e '/if.*=~.*(OBSOLETE|CURL_EXTERN|CURL_STRICTER)/s,/[^/]+/,/($ENV{_CURL_BUILD_SYM_EXCLUDE})/aax,g' \
		"${S}/Makefile.PL"
}

# https://src.fedoraproject.org/rpms/perl-WWW-Curl/blob/rawhide/f/WWW-Curl-4.17-Skip-preprocessor-symbol-only-CURL_STRICTER.patch
# /(OBSOLETE|^CURL_EXTERN|^CURL_STRICTER\z|_LAST\z|_LASTENTRY\z)/
#
# files/WWW-Curl-4.17-RT117793.patch
# /(OBSOLETE|^CURL_EXTERN|^CURL_STRICTER\z|^CURL_DID_MEMORY_FUNC_TYPEDEFS\z|_LAST\z|_LASTENTRY\z)/)
#
# files/WWW-Curl-4.17-RT130591.patch
# /(OBSOLETE|^CURL_EXTERN|^CURL_STRICTER\z|^CURL_DID_MEMORY_FUNC_TYPEDEFS\z|_LAST\z|_LASTENTRY\z|^CURLINC_)/
#
# https://rt.cpan.org/Public/Bug/Display.html?id=132197
# /(OBSOLETE|^CURL_EXTERN|^CURL_STRICTER\z|^CURL_DID_MEMORY_FUNC_TYPEDEFS\z|_LAST\z|_LASTENTRY\z|^CURLINC_|^CURL_WIN32\z|^CURLOPT\z)/
#
# https://src.fedoraproject.org/rpms/perl-WWW-Curl/blob/rawhide/f/WWW-Curl-4.17-Adapt-to-curl-7.87.0.patch
# /(OBSOLETE|^CURL_DEPRECATED\z|^CURL_EXTERN|^CURL_IGNORE_DEPRECATION\z|^CURL_STRICTER\z|^CURL_WIN32\z|^CURLOPT\z|^CURLOPTDEPRECATED\z|_LAST\z|_LASTENTRY\z)
#
# If you change this variable, you should probably be bumping the ebuild rev!
export _CURL_BUILD_SYM_EXCLUDE='
__000FORPATCH_WITH_LEADING_SPACE
|^CURL_DEPRECATED\z
|^CURL_DID_MEMORY_FUNC_TYPEDEFS\z
|^CURL_EXTERN
|^CURL_IGNORE_DEPRECATION\z
|^CURLINC_
|^CURLOPTDEPRECATED\z
|^CURLOPT\z
|^CURL_STRICTER\z
|^CURL_WIN32\z
|_LASTENTRY\z
|_LAST\z
|OBSOLETE
'

PERL_RM_FILES=("t/meta.t" "t/pod-coverage.t" "t/pod.t")
