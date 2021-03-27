# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Serial Communication Program"
HOMEPAGE="https://salsa.debian.org/minicom-team/minicom"
SRC_URI="https://alioth-archive.debian.org/releases/minicom/Source/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls"

COMMON_DEPEND="sys-libs/ncurses:="
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}
	net-dialup/lrzsz"

DOCS="AUTHORS ChangeLog NEWS README doc/minicom.FAQ"
S="${WORKDIR}/${PN}-2.7" # 2.7.1 specific

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-gentoo-runscript.patch
	"${FILESDIR}"/${PN}-2.7-lockdir.patch
	"${FILESDIR}"/${PN}-2.7.1-gcc-10.patch
	"${FILESDIR}"/${PN}-2.7.1-musl.patch
)

src_prepare() {
	default
	mv "${S}"/configure.{in,ac}
	eautoreconf
}

src_configure() {
	# Lockdir must exist if not manually specified.
	# /var/lock is created by openrc.
	LOCKDIR=/var/lock
	econf \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--enable-lock-dir="${LOCKDIR}" \
		$(use_enable nls)
}

src_install() {
	default
	insinto /etc/minicom
	doins "${FILESDIR}"/minirc.dfl
}

pkg_preinst() {
	[[ -s ${EROOT}/etc/minicom/minirc.dfl ]] && rm -f "${ED}"/etc/minicom/minirc.dfl
}
