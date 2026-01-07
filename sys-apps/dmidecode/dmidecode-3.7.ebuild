# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream often give "recommended patches" at https://www.nongnu.org/dmidecode/
# Check regularly after releases!
inherit bash-completion-r1 flag-o-matic toolchain-funcs

UPSTREAM_PATCH_COMMITS=()
DESCRIPTION="DMI (Desktop Management Interface) table related utilities"
HOMEPAGE="https://www.nongnu.org/dmidecode/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"
for commit in "${UPSTREAM_PATCH_COMMITS[@]}" ; do
	SRC_URI+=" https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=${commit} -> ${P}-${commit}.patch"
	UPSTREAM_PATCHES+=( "${DISTDIR}"/${P}-${commit}.patch )
done
unset commit

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-dmidecode )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${UPSTREAM_PATCHES[@]}"
)

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

src_install() {
	einstalldocs
	emake DESTDIR="${D}" compdir="$(get_bashcompdir)" install
}

pkg_postinst() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		einfo "dmidecode needs root privileges to read /dev/xsvc"
		einfo "To make dmidecode useful, either run as root, or chown and setuid the binary."
		einfo "Note that /usr/sbin/ptrconf and /usr/sbin/ptrdiag give similar"
		einfo "information without requiring root privileges."
	fi
}
