# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/spidermonkey/spidermonkey-1.8.2.15-r2.ebuild,v 1.10 2015/04/08 08:22:09 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"
inherit eutils toolchain-funcs multilib python-any-r1

MY_PV="${PV}"
MY_PV="${MY_PV/1.8.2/3.6}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
REL_URI="http://releases.mozilla.org/pub/mozilla.org/firefox/releases"
SRC_URI="${REL_URI}/${MY_PV}/source/firefox-${MY_PV}.source.tar.bz2"

LICENSE="NPL-1.1"
SLOT="0/mozjs"
KEYWORDS="alpha amd64 arm ppc ppc64 sparc x86 ~x86-fbsd ~x64-macos ~x86-macos"
IUSE="threadsafe"

S="${WORKDIR}/mozilla-1.9.2"
BUILDDIR="${S}/js/src"

RDEPEND="threadsafe? ( >=dev-libs/nspr-4.8.6 )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-arch/zip
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.9.2.13-as-needed.patch"

	epatch_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -s "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk"
	fi
}

src_configure() {
	cd "${BUILDDIR}" || die

	local myconf

	use threadsafe && myconf="${myconf} \
		--with-system-nspr --enable-threadsafe"

	# Disable no-print-directory
	MAKEOPTS=${MAKEOPTS/--no-print-directory/}

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
	AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
	LD="$(tc-getLD)" econf \
		${myconf}
}

src_compile() {
	cd "${BUILDDIR}" || die
	emake -j1
}

src_install() {
	cd "${BUILDDIR}" || die
	emake install DESTDIR="${D}"
	dobin shell/js
	dodoc ../jsd/README
	dohtml README.html

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name
		install_name_tool -id "${EPREFIX}"/usr/$(get_libdir)/libmozjs.dylib \
			"${ED}"/usr/$(get_libdir)/libmozjs.dylib || die
	fi
}
