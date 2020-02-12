# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cmake pam tmpfiles

MY_P=${PN}_${PV/_p/-}

DESCRIPTION="Utility to execute commands in a chroot environment"
HOMEPAGE="https://packages.debian.org/source/sid/schroot"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${MY_P/%-*/}.orig.tar.xz
	mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="btrfs +dchroot debug doc lvm nls pam test zfs"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/boost-1.42.0:=
	>=sys-apps/util-linux-2.16
	btrfs? ( >=sys-fs/btrfs-progs-0.19-r2 )
	lvm? ( sys-fs/lvm2 )
	pam? ( sys-libs/pam )
	zfs? ( sys-fs/zfs )
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

S="${WORKDIR}/${PN}-${PV/%_p*/}"

src_unpack() {
	unpack ${MY_P/%-*/}.orig.tar.xz
	cd "${S}"
	unpack ${MY_P}.debian.tar.xz
}

src_prepare() {
	sed -i -e 's/warn(/message(WARNING /' man/CMakeLists.txt || die
	eapply "${S}"/debian/patches/*.patch
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Dbtrfs-snapshot=$(usex btrfs)
		-Ddchroot=$(usex dchroot)
		-Ddchroot-dsa=$(usex dchroot)
		-Ddebug=$(usex debug)
		-Ddoxygen=$(usex doc)
		-Dlvm-snapshot=$(usex lvm)
		-Dnls=$(usex nls)
		-Dpam=$(usex pam)
		-Dtest=$(usex test)
		-Dzfs-snapshot=$(usex zfs)
		-Dbash_completion_dir="$(get_bashcompdir)"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCMAKE_INSTALL_LOCALSTATEDIR="${EPREFIX}/var"
		-DSCHROOT_MOUNT_DIR="${EPREFIX}/run/${PN}/mount"
	)
	if ! use nls; then
		mycmakeargs+=(-DPO4A_EXECUTABLE=NOTFOUND)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(usev doc)
}

src_test() {
	if [[ $EUID -ne 0 ]]; then
		ewarn "Disabling tests because you are not root"
		return 0
	fi

	cmake_src_test
}

src_install() {
	cmake_src_install

	keepdir /var/lib/schroot/{session,unpack,union/{overlay,underlay}}

	docinto /usr/share/doc/${PF}/contrib/setup.d
	dodoc contrib/setup.d/05customdir contrib/setup.d/09fsck contrib/setup.d/10mount-ssh

	newdoc debian/schroot.NEWS NEWS.debian

	newinitd "${FILESDIR}"/schroot.initd schroot
	newconfd "${FILESDIR}"/schroot.confd schroot
	newtmpfiles "${FILESDIR}"/schroot.tmpfilesd schroot.conf

	if use doc; then
		docinto html/sbuild
		dodoc "${BUILD_DIR}"/doc/sbuild/html/*
		docinto html/schroot
		dodoc "${BUILD_DIR}"/doc/schroot/html/*
	fi

	if use pam; then
		rm -f "${ED}"/etc/pam.d/schroot
		pamd_mimic_system schroot auth account session
	fi
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
