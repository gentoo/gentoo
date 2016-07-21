# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MY_PN="PRoot"

inherit eutils pax-utils toolchain-funcs

DESCRIPTION="User-space implementation of chroot, mount --bind, and binfmt_misc"
HOMEPAGE="http://proot.me"
SRC_URI="https://github.com/cedric-vincent/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="care test"

RDEPEND="care? ( app-arch/libarchive:0= )
	 sys-libs/talloc"
DEPEND="${RDEPEND}
	care? ( dev-libs/uthash )
	test? ( dev-util/valgrind )"

# Breaks sandbox
RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	epatch  "${FILESDIR}/${PN}-3.2.1-makefile.patch" \
		"${FILESDIR}/${PN}-2.3.1-lib-paths-fix.patch" \
		"${FILESDIR}/${P}-build-care.patch"
	epatch_user
}

src_compile() {
	# build the proot and care targets
	emake -C src V=1 \
		CC="$(tc-getCC)" \
		CHECK_VERSION="true" \
		CAREBUILDENV="ok" \
		proot $(usex care "care" "" "" "")
}

src_install() {
	if use care; then
		# Workaround for bug #493416
		pax-mark -Emp src/care
		dobin src/care
	fi
	# Workaround for bug #493416
	pax-mark -Emp src/proot

	dobin src/proot
	doman doc/proot.1
	dodoc doc/*.txt doc/articles/*
}

src_test() {
	emake -C tests -j1 CC="$(tc-getCC)"
}

pkg_postinst() {
	if use care; then
		elog "You have enabled 'care' USE flag, that builds and installs"
		elog "dynamically linked care binary."
		elog "Upstream does NOT support such way of building CARE,"
		elog "it provides only prebuilt binaries."
		elog "CARE also has known problems on hardened systems"
		elog "Please do NOT file bugs about them to https://bugs.gentoo.org"
	fi
}
