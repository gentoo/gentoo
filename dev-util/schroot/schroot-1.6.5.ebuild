# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/schroot/schroot-1.6.5.ebuild,v 1.2 2013/03/06 20:22:29 steev Exp $

EAPI="4"

inherit autotools base eutils pam versionator

MY_P=${PN}_${PV}
DEB_REL=1

DESCRIPTION="Utility to execute commands in a chroot environment"
HOMEPAGE="http://packages.debian.org/source/sid/schroot"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}.orig.tar.xz
	mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}-${DEB_REL}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="btrfs +dchroot debug doc lvm nls pam test"

COMMON_DEPEND="
	>=dev-libs/boost-1.42.0
	dev-libs/lockdev
	>=sys-apps/util-linux-2.16
	btrfs? ( >=sys-fs/btrfs-progs-0.19-r2 )
	lvm? ( sys-fs/lvm2 )
	pam? ( sys-libs/pam )
"

DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	sys-apps/groff
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? (
		>=app-text/po4a-0.40
		sys-devel/gettext
	)
	test? ( >=dev-util/cppunit-1.10.0 )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/debianutils
	dchroot? ( !sys-apps/dchroot )
	nls? ( virtual/libintl )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.6.3-tests.patch"
)

src_unpack() {
	unpack ${MY_P}.orig.tar.xz
	cd "${S}"
	unpack ${MY_P}-${DEB_REL}.debian.tar.gz
}

src_prepare() {
	base_src_prepare

	# Don't depend on cppunit unless we are testing
	use test || sed -i '/AM_PATH_CPPUNIT/d' configure.ac

	eautoreconf
}

src_configure() {
	root_tests=no
	use test && (( EUID == 0 )) && root_tests=yes
	use nls || export ac_cv_path_PO4A=
	econf \
		$(use_enable btrfs btrfs-snapshot) \
		$(use_enable doc doxygen) \
		$(use_enable dchroot) \
		$(use_enable dchroot dchroot-dsa) \
		$(use_enable debug) \
		$(use_enable lvm lvm-snapshot) \
		$(use_enable nls) \
		$(use_enable pam) \
		--enable-block-device \
		--enable-loopback \
		--enable-uuid \
		--enable-root-tests=$root_tests \
		--enable-shared \
		--disable-static \
		--localstatedir="${EPREFIX}"/var \
		--with-bash-completion-dir="${EPREFIX}"/usr/share/bash-completion
}

src_compile() {
	emake all $(usev doc)
}

src_test() {
	if [[ $root_tests == yes && $EUID -ne 0 ]]; then
		ewarn "Disabling tests because you are no longer root"
		return 0
	fi

	# Fix a bug in the tarball -- an empty directory was omitted
	mkdir test/run-parts.ex2
	default
}

src_install() {
	default

	insinto /usr/share/doc/${PF}/contrib/setup.d
	doins contrib/setup.d/05customdir contrib/setup.d/09fsck contrib/setup.d/10mount-ssh

	newdoc debian/schroot.NEWS NEWS.debian

	newinitd "${FILESDIR}"/schroot.initd schroot
	newconfd "${FILESDIR}"/schroot.confd schroot

	if use doc; then
		docinto html/sbuild
		dohtml doc/sbuild/html/*
		docinto html/schroot
		dohtml doc/schroot/html/*
	fi

	if use pam; then
		rm -f "${ED}"etc/pam.d/schroot
		pamd_mimic_system schroot auth account session
	fi

	# Remove *.la files
	find "${D}" -name "*.la" -exec rm {} + || die "removal of *.la files failed"
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} == 1.[24]* ]]; then
		elog "Please read /usr/share/doc/${PF}/NEWS.debian* for important"
		elog "upgrade information."
	fi
}
