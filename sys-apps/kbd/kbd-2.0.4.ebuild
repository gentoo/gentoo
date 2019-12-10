# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

SCM=""
if [[ ${PV} == "9999" ]] ; then
	SCM="autotools git-r3"
	EGIT_REPO_URI="https://git.kernel.org/cgit/linux/kernel/git/legion/${PN}.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://www.kernel.org/pub/linux/utils/kbd/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
fi

inherit eutils ${SCM}

DESCRIPTION="Keyboard and console utilities"
HOMEPAGE="http://kbd-project.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls pam test"
RESTRICT="!test? ( test )"

RDEPEND="pam? ( sys-libs/pam )
	app-arch/gzip"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
	else
		default
	fi

	# Rename conflicting keymaps to have unique names, bug #293228
	cd "${S}"/data/keymaps/i386 || die
	mv dvorak/no.map dvorak/no-dvorak.map || die
	mv fgGIod/trf.map fgGIod/trf-fgGIod.map || die
	mv olpc/es.map olpc/es-olpc.map || die
	mv olpc/pt.map olpc/pt-olpc.map || die
	mv qwerty/cz.map qwerty/cz-qwerty.map || die
}

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable pam vlock) \
		$(use_enable test tests)
}

src_install() {
	default
	dohtml docs/doc/*.html
}
