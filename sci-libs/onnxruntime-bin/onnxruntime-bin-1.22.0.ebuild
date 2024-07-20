# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="cross-platform, high performance ML inferencing and training accelerator"
HOMEPAGE="https://onnxruntime.ai/"

SRC_URI="
	https://github.com/microsoft/onnxruntime/releases/download/v${PV}/onnxruntime-linux-x64-${PV}.tgz
"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64"

DOCS="
	README.md
	Privacy.md
	ThirdPartyNotices.txt
	LICENSE
"

QA_PREBUILT="
	lib*/lib*.so*
"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}" || die
	mv onnxruntime-linux-* ${P} || die
}

src_install() {
	dodir /usr/include
	cp -R include/. "${ED}"/usr/include/. || die

	dodir $(get_libdir)
	cp -R lib/. "${ED}"/$(get_libdir)/. || die

	einstalldocs
}
