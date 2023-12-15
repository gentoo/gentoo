# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/legionus/kbd.git https://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	if [[ $(ver_cut 3) -lt 90 ]] ; then
		SRC_URI="https://www.kernel.org/pub/linux/utils/kbd/${P}.tar.xz"
		KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86"
	else
		SRC_URI="https://github.com/legionus/kbd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
fi

DESCRIPTION="Keyboard and console utilities"
HOMEPAGE="https://kbd-project.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls selinux pam test"
RESTRICT="!test? ( test )"

# Testsuite's Makefile.am calls missing(!)
# ... but this seems to be consistent with the autoconf docs?
# Needs more investigation: https://www.gnu.org/software/autoconf/manual/autoconf-2.67/html_node/autom4te-Invocation.html
QA_AM_MAINTAINER_MODE=".*--run autom4te --language=autotest.*"

DEPEND="
	app-alternatives/gzip
	pam? (
		!app-misc/vlock
		sys-libs/pam
	)
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-loadkeys )
"
# autoconf-archive for F_S patch
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.3-no-redefine-fortify-source.patch
)

src_prepare() {
	default

	# Rename conflicting keymaps to have unique names, bug #293228
	# See also https://github.com/legionus/kbd/issues/76.
	pushd "${S}"/data/keymaps/i386 &> /dev/null || die
	mv fgGIod/trf.map fgGIod/trf-fgGIod.map || die
	mv olpc/es.map olpc/es-olpc.map || die
	mv olpc/pt.map olpc/pt-olpc.map || die
	mv qwerty/cz.map qwerty/cz-qwerty.map || die
	popd &> /dev/null || die

	#if [[ ${PV} == 9999 ]] || [[ $(ver_cut 3) -ge 90 ]] ; then
	#	eautoreconf
	#fi

	# Always do it for now for the F_S patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror

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

	# USE="test" installs .la files
	find "${ED}" -type f -name "*.la" -delete || die
}
