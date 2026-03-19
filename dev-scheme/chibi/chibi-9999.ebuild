# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Minimal Scheme implementation for use as an extension language"
HOMEPAGE="http://synthcode.com/scheme/chibi/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ashinn/${PN}-scheme"
else
	SRC_URI="https://github.com/ashinn/${PN}-scheme/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-scheme-${PV}"

	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0"

src_install() {
	cmake_src_install
	dosym -r /usr/bin/${PN}{-scheme,}
}
