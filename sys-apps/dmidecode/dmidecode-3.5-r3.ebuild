# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream often give "recommended patches" at https://www.nongnu.org/dmidecode/
# Check regularly after releases!
inherit flag-o-matic toolchain-funcs


DESCRIPTION="DMI (Desktop Management Interface) table related utilities"
HOMEPAGE="https://www.nongnu.org/dmidecode/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.xz"
PATCHES=()
UPSTREAM_PATCHES=(
	c76ddda0ba0aa99a55945e3290095c2ec493c892
	80de376231e903d2cbea95e51ffea31860502159
)

for c in "${UPSTREAM_PATCHES[@]}" ; do
	SRC_URI+=" https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=${c} -> ${P}-${c}.patch "
	PATCHES+=( "${DISTDIR}"/${P}-${c}.patch )
done

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-dmidecode )"

src_prepare() {
	default

	sed -i \
		-e "/^prefix/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^docdir/s:dmidecode:${PF}:" \
		-e '/^PROGRAMS !=/d' \
		Makefile || die
}

src_compile() {
	append-lfs-flags

	emake \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

pkg_postinst() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		einfo "dmidecode needs root privileges to read /dev/xsvc"
		einfo "To make dmidecode useful, either run as root, or chown and setuid the binary."
		einfo "Note that /usr/sbin/ptrconf and /usr/sbin/ptrdiag give similar"
		einfo "information without requiring root privileges."
	fi
}
