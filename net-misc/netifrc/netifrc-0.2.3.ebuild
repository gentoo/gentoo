# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils udev

DESCRIPTION="Gentoo Network Interface Management Scripts"
HOMEPAGE="https://www.gentoo.org/proj/en/base/openrc/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~robbat2/distfiles/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE=""

COMMON_DEPEND="!<sys-fs/udev-init-scripts-26-r1
	!<sys-fs/udev-172"
DEPEND="${COMMON_DEPEND}
	kernel_linux? ( virtual/pkgconfig )"
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/openrc-0.12
	!<sys-apps/openrc-0.12"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		local ver="git-${EGIT_VERSION:0:6}"
		sed -i "/^GITVER[[:space:]]*=/s:=.*:=${ver}:" mk/git.mk || die
		einfo "Producing ChangeLog from Git history"
		GIT_DIR="${S}/.git" git log >"${S}"/ChangeLog
	fi

	# Allow user patches to be applied without modifying the ebuild
	epatch_user
}

src_compile() {
	MAKE_ARGS="${MAKE_ARGS}
		LIBEXECDIR=${EPREFIX}/lib/${PN} PF=${PF}
		UDEVDIR=$(get_udevdir)"

	use prefix && MAKE_ARGS="${MAKE_ARGS} MKPREFIX=yes PREFIX=${EPREFIX}"

	emake ${MAKE_ARGS} all
}

src_install() {
	emake ${MAKE_ARGS} DESTDIR="${D}" install
	dodoc README CREDITS FEATURE-REMOVAL-SCHEDULE STYLE TODO ChangeLog
}

pkg_postinst() {
	if [[ ! -e "${EROOT}"/etc/conf.d/net && -z $REPLACING_VERSIONS ]]; then
		elog "The network configuration scripts will use dhcp by"
		elog "default to set up your interfaces."
		elog "If you need to set up something more complete, see"
		elog "${EROOT}/usr/share/doc/${P}/README"
	fi
}
