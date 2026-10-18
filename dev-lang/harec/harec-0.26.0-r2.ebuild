# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

if [[ "${PV}" = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/harec"
else
	MY_PV="$(ver_rs 3 -)"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://git.sr.ht/~sircmpwn/harec/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

DESCRIPTION="The Hare compiler"
HOMEPAGE="https://harelang.org/"

LICENSE="GPL-3"
SLOT="0"

DEPEND=">=sys-devel/qbe-1.2"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	local target_triple="${CTARGET:-${CHOST}}"

	cp configs/linux.mk config.mk || die
	sed -i \
		-e "s;^ARCH =.*;ARCH = ${target_triple/-*};" \
		-e "s;^PREFIX =.*;PREFIX = ${EPREFIX}/usr;" \
		-e 's/^CC =/CC ?=/' \
		-e 's/^AS =/AS ?=/' \
		-e 's/^LD =/LD ?=/' \
		-e 's/^CFLAGS =/CFLAGS +=/' \
		-e 's/-Werror//' \
		-e 's/^LDFLAGS =/LDFLAGS ?=/' \
		-e 's/^LDLINKFLAGS =/LDLINKFLAGS ?=/' \
		config.mk || die

	tc-export CC AS LD
}
