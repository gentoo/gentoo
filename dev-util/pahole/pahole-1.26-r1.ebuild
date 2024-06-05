# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
inherit cmake python-single-r1

MY_PN=dwarves
MY_P=${MY_PN}-${PV%%_p*}

DESCRIPTION="pahole (Poke-a-Hole) and other DWARF2 utilities"
HOMEPAGE="https://git.kernel.org/cgit/devel/pahole/pahole.git/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/devel/pahole/pahole.git"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/arnaldocarvalhodemelo.asc
	inherit verify-sig
	SRC_URI="http://fedorapeople.org/~acme/${MY_PN}/${MY_P}.tar.xz
		verify-sig? ( http://fedorapeople.org/~acme/${MY_PN}/${MY_P}.tar.sign )"
	if [[ ${PV} == *_p* ]] ; then
		# Patch rollups from git format-patch. Sometimes there are important
		# fixes in git which haven't been released (and no release in sight).
		# Patch rollups are a bit better for understanding where changes have
		# come from for users.
		SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches.tar.xz"
	fi
	S="${WORKDIR}"/${MY_P}
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-arnaldocarvalhodemelo )"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2" # only
SLOT="0"
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/elfutils-0.178
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( README README.ctracer NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-1.10-python-import.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		return
	elif use verify-sig ; then
		mkdir "${T}"/verify-sig || die
		pushd "${T}"/verify-sig &>/dev/null || die

		# Upstream sign the decompressed .tar
		# Let's do it separately in ${T} then cleanup to avoid external
		# effects on normal unpack.
		xz -d -c "${DISTDIR}"/${MY_P}.tar.xz > ${MY_P}.tar || die
		verify-sig_verify_detached ${MY_P}.tar "${DISTDIR}"/${MY_P}.tar.sign

		popd &>/dev/null || die
		rm -r "${T}"/verify-sig || die
	fi

	default
}

src_prepare() {
	[[ -d "${WORKDIR}"/${P}-patches ]] && PATCHES+=( "${WORKDIR}"/${P}-patches )

	cmake_src_prepare
	python_fix_shebang ostra/ostra-cg ostra/python/ostra.py
}

src_configure() {
	local mycmakeargs=( "-D__LIB=$(get_libdir)" )
	cmake_src_configure
}
