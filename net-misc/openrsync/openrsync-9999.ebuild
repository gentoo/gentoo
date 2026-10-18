# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit multiprocessing toolchain-funcs

DESCRIPTION="BSD-licensed implementation of rsync"
HOMEPAGE="https://www.openrsync.org/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/kristapsdz/openrsync"
	inherit git-r3
elif [[ ${PV} == *_p* ]] ; then
	OPENRSYNC_COMMIT="1878c030a784de38903afe422119ac0a84e0c4f1"
	SRC_URI="https://github.com/kristapsdz/openrsync/archive/${OPENRSYNC_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${OPENRSYNC_COMMIT}
else
	SRC_URI="https://github.com/kristapsdz/openrsync/archive/refs/tags/VERSION_$(ver_rs 3 _).tar.gz -> ${P}.tar.gz"
fi

LICENSE="ISC"
SLOT="0"
if [[ ${PV} != 9999 ]] ; then
	KEYWORDS="~amd64 ~ppc ~x86"
fi
IUSE="test"
RESTRICT="!test? ( test )"

# https://github.com/kristapsdz/openrsync/issues/46
BDEPEND="
	dev-build/bmake
	test? (
		app-misc/jot
		dev-util/cunit
		net-misc/rsync
	)
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# OpenBSD
	crypt_checkpass crypt_newhash errc getexecname getprogname
	memset_s pledge recallocarray strtonum TAILQ_FOREACH_SAFE
	timingsafe_bcmp timingsafe_memcmp unveil warnc
)

src_configure() {
	tc-export CC

	local confargs=(
		PREFIX="${EPREFIX}"/usr
		MANDIR="${EPREFIX}"/usr/share/man
	)

	edo ./configure "${confargs[@]}"
}

src_compile() {
	local jobs="$(get_makeopts_jobs)"
	unset MAKEOPTS
	unset MAKEFLAGS

	export MAKEOPTS="-j${jobs}"
	export MAKEFLAGS=
	export MAKE=bmake

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" regress
}
