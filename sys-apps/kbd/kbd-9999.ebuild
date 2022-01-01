# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam

if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-r3
	#EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git"
	EGIT_REPO_URI="https://github.com/legionus/kbd.git"
	EGIT_BRANCH="master"
else
	if [[ $(ver_cut 3) -lt 90 ]] ; then
		SRC_URI="https://www.kernel.org/pub/linux/utils/kbd/${P}.tar.xz"
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	else
		inherit autotools
		SRC_URI="https://github.com/legionus/kbd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
fi

DESCRIPTION="Keyboard and console utilities"
HOMEPAGE="http://kbd-project.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls pam test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/gzip
	pam? (
		!app-misc/vlock
		sys-libs/pam
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-libs/check )
"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
	else
		default
	fi

	# Rename conflicting keymaps to have unique names, bug #293228
	cd "${S}"/data/keymaps/i386 || die
	mv fgGIod/trf.map fgGIod/trf-fgGIod.map || die
	mv olpc/es.map olpc/es-olpc.map || die
	mv olpc/pt.map olpc/pt-olpc.map || die
	mv qwerty/cz.map qwerty/cz-qwerty.map || die
}

src_prepare() {
	default
	if [[ ${PV} == "9999" ]] || [[ $(ver_cut 3) -ge 90 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable pam vlock)
		$(use_enable test tests)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	docinto html
	dodoc docs/doc/*.html
	use pam && pamd_mimic_system vlock auth account
}
