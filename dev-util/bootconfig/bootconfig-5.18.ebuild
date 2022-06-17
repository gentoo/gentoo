# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit estack linux-info

DESCRIPTION="Bootconfig tools for kernel command line to support key-value"
HOMEPAGE="https://kernel.org/"

LINUX_V="${PV:0:1}.x"
if [[ ${PV} == *_rc* ]] ; then
	LINUX_VER=$(ver_cut 1-2).$(($(ver_cut 3)-1))
	PATCH_VERSION=$(ver_cut 1-3)
	LINUX_PATCH=patch-${PV//_/-}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/testing/${LINUX_PATCH}
		https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/testing/v${PATCH_VERSION}/${LINUX_PATCH}"
elif [[ ${PV} == *.*.* ]] ; then
	# stable-release series
	LINUX_VER=$(ver_cut 1-2)
	LINUX_PATCH=patch-${PV}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_PATCH}"
else
	LINUX_VER=${PV}
	SRC_URI=""
fi

LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
SRC_URI+=" https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="examples"

BDEPEND="
	${LINUX_PATCH+dev-util/patchutils}
"

RDEPEND=""

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-5.10
"

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/bootconfig"

CONFIG_CHECK="~BOOT_CONFIG"

PATCHES=( "${FILESDIR}"/${P}-cflags.patch )

src_unpack() {
	local paths=(
		tools/arch tools/build tools/include tools/lib tools/bootconfig tools/scripts
		scripts include lib "arch/*/lib"
	)

	# We expect the tar implementation to support the -j option (both
	# GNU tar and libarchive's tar support that).
	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	tar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die

	if [[ -n ${LINUX_PATCH} ]] ; then
		eshopts_push -o noglob
		ebegin "Filtering partial source patch"
		filterdiff -p1 ${paths[@]/#/-i } -z "${DISTDIR}"/${LINUX_PATCH} \
			> ${P}.patch
		eend $? || die "filterdiff failed"
		eshopts_pop
	fi

	local a
	for a in ${A}; do
		[[ ${a} == ${LINUX_SOURCES} ]] && continue
		[[ ${a} == ${LINUX_PATCH} ]] && continue
		unpack ${a}
	done
}

src_prepare() {
	default
	if [[ -n ${LINUX_PATCH} ]] ; then
		pushd "${S_K}" >/dev/null || die
		eapply "${WORKDIR}"/${P}.patch
		popd || die
	fi
}

src_compile() {
	emake bootconfig
}

src_test() {
	:
}

src_install() {
	dobin bootconfig

	if use examples; then
		dodoc -r scripts

		docinto examples
		dodoc -r samples/*
	fi
}
