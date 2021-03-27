# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Serial Communication Program"
HOMEPAGE="https://salsa.debian.org/minicom-team/minicom"
SRC_URI="https://salsa.debian.org/${PN}-team/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="nls"

DEPEND="sys-libs/ncurses:="

RDEPEND="
	${DEPEND}
	net-dialup/lrzsz
"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.8-gentoo-runscript.patch
	"${FILESDIR}"/${PN}-2.8-lockdir.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Lockdir must exist if not manually specified.
	# '/var/lock' is created by OpenRC.
	local myeconfargs=(
		--disable-rpath
		--enable-lock-dir="/var/lock"
		$(use_enable nls)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc/minicom
	doins "${FILESDIR}"/minirc.dfl
}

pkg_preinst() {
	[[ -s "${EROOT}"/etc/minicom/minirc.dfl ]] && rm -f "${ED}"/etc/minicom/minirc.dfl
}
