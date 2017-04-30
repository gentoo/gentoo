# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils autotools

STUPID_NUM="3977"
DESCRIPTION="Serial Communication Program"
HOMEPAGE="http://alioth.debian.org/projects/minicom"
SRC_URI="https://alioth.debian.org/frs/download.php/file/${STUPID_NUM}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="nls"

COMMON_DEPEND="sys-libs/ncurses:="
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}
	net-dialup/lrzsz"

DOCS="AUTHORS ChangeLog NEWS README doc/minicom.FAQ"
S="${WORKDIR}/${PN}-2.7" # 2.7.1 specific

# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" cs da de es fi fr hu id ja nb pl pt_BR ro ru rw sv vi zh_TW"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-gentoo-runscript.patch
	"${FILESDIR}"/${PN}-2.7-lockdir.patch
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
