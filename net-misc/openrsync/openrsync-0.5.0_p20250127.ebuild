# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

DESCRIPTION="BSD-licensed implementation of rsync"
HOMEPAGE="https://www.openrsync.org/"

if [[ ${PV} == *_p* ]] ; then
	OPENRSYNC_COMMIT="a257c0f495af2b5ee6b41efc6724850a445f87ed"
	SRC_URI="https://github.com/kristapsdz/openrsync/archive/${OPENRSYNC_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${OPENRSYNC_COMMIT}
else
	SRC_URI="https://github.com/kristapsdz/openrsync/archive/refs/tags/VERSION_$(ver_rs 3 _).tar.gz -> ${P}.tar.gz"
fi

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

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
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
