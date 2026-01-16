# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-single-r1

MY_PN=dwarves
MY_P=${MY_PN}-${PV%%_p*}

DESCRIPTION="pahole (Poke-a-Hole) and other DWARF utilities"
HOMEPAGE="https://git.kernel.org/cgit/devel/pahole/pahole.git/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_BRANCH="next"
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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="GPL-2" # only
SLOT="0"
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/elfutils-0.178
	virtual/zlib:="
DEPEND="${RDEPEND}"

DOCS=( README README.ctracer NEWS )

PATCHES=(
	"${FILESDIR}/${PN}-1.10-python-import.patch"
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		return
	fi

	if use verify-sig; then
		verify-sig_uncompress_verify_unpack "${DISTDIR}"/${MY_P}.tar.xz \
			"${DISTDIR}"/${MY_P}.tar.sign
	else
		default
	fi
}

src_prepare() {
	[[ -d "${WORKDIR}"/${P}-patches ]] && PATCHES+=( "${WORKDIR}"/${P}-patches )

	cmake_src_prepare
	python_fix_shebang ostra/ostra-cg ostra/python/ostra.py
}
