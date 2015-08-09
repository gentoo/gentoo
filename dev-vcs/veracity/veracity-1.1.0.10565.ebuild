# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit bash-completion-r1 eutils cmake-utils

JS_P=js-1.8.0-rc1

DESCRIPTION="A modern and featureful DVCS (distributed version control system)"
HOMEPAGE="http://veracity-scm.com/"
SRC_URI="http://download.sourcegear.com/Veracity/release/${PV}/${PN}-source-${PV}.tar.gz

	ftp://ftp.mozilla.org/pub/mozilla.org/js/${JS_P}.tar.gz
	http://ftp.mozilla.org/pub/mozilla.org/js/${JS_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="test"

S=${WORKDIR}/${PN}

# Tests fail in 1.0.0.10517.
RESTRICT=test

# Veracity can only use the API from spidermonkey-1.8.0 which isn't
# available in gentoo-x86. It seems that spidermonkey needs to be
# SLOTed... because Veracity needs differing amounts of nontrivial work
# to support spidermonkey-1.8.2 or any newer spidermonkey.
#
# || ( >=dev-lang/spidermonkey-1.8[threadsafe] >=dev-lang/spidermonkey-1.8.5 )
RDEPEND="
	dev-libs/icu
	net-misc/curl
	dev-libs/nspr
	sys-apps/util-linux
	dev-db/sqlite:3
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( app-arch/unzip )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.0.10517-werror.patch
	epatch "${FILESDIR}"/${PN}-1.0.0.10517-system-sqlite.patch
	epatch "${FILESDIR}"/${PN}-1.0.0.10517-spidermonkey-as-needed.patch

	rm -rf src/thirdparty || die

	pushd "${WORKDIR}"/js || die
	(
		EPATCH_OPTS+=" -p8"
		epatch "${S}"/thirdparty/patches/js-1.8.0-rc1__{jsapi.c,jscntxt.{c,h}}.patch
	)
}

src_configure() {
	# Convince cmake scripts that spidermonkey has been prepared.
	mkdir -p thirdparty/{include/spidermonkey,lib} || die

	local mycmakeargs=(
		-DVVTHIRDPARTY="${S}"/thirdparty
		-DSPIDERMONKEY_INCDIR="${S}"/thirdparty/include
		-DSPIDERMONKEY_LIB="${S}"/thirdparty/lib/libjs.a
	)
	cmake-utils_src_configure
}

src_compile() {
	einfo "Compiling embedded spidermonkey (${JS_P})."
	# Based on thirdparty/build_linux.sh.
	emake -j1 \
		-C "${WORKDIR}"/js/src \
		JS_DIST="${EPREFIX}"/usr \
		JS_THREADSAFE=1 \
		BUILD_OPT=1 \
		-f Makefile.ref
	cp "${WORKDIR}"/js/src/{*.{h,msg,tbl},Linux_All_OPT.OBJ/*.h} thirdparty/include/spidermonkey/ \
		|| die "Preparing embedded spidermonkey."
	cp "${WORKDIR}"/js/src/Linux_All_OPT.OBJ/libjs.a thirdparty/lib/ \
		|| die "Preparing embedded spidermonkey."

	einfo "Compiling ${P}."
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	rm -f "${D}"/etc/bash-completion.d || die
	newbashcomp src/cmd/vv.bash_completion vv
}
