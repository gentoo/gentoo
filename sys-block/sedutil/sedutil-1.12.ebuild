# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="The Drive Trust Alliance Self Encrypting Drive Utility"
HOMEPAGE="https://github.com/Drive-Trust-Alliance/sedutil"
SRC_URI="https://github.com/Drive-Trust-Alliance/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	# https://github.com/Drive-Trust-Alliance/sedutil/pull/49
	find -name '*.mk' -exec sed -E -i 's: -(Werror|g|O[0-9]?) : :g' {} + || die
	# https://github.com/Drive-Trust-Alliance/sedutil/issues/52
	if has_version '>=sys-kernel/linux-headers-4.4' ; then
		mkdir linux/linux || die
		cp "${FILESDIR}"/nvme.h linux/linux/ || die
	fi
}

src_configure() {
	case $(tc-arch) in
	x86)   sedutil_arch="Release_i686" ;;
	amd64) sedutil_arch="Release_x86_64" ;;
	*)     die "unsupported architecture" ;;
	esac
}

src_compile() {
	emake \
		-C "linux/CLI" \
		V=1 \
		CONF="${sedutil_arch}" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dobin "linux/CLI/dist/${sedutil_arch}/GNU-Linux/sedutil-cli"
	dodoc README.md
}
