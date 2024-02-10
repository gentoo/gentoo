# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Flycheck syntax checker using clang-tidy"
HOMEPAGE="https://github.com/ch1bo/flycheck-clang-tidy"
if [[ ${PV} == *_p* ]] ; then
	MY_COMMIT="f9ae7306bd6ca08b689b36c1e8f6f6b91d61db5f"
	SRC_URI="https://github.com/ch1bo/flycheck-clang-tidy/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_COMMIT}
else
	SRC_URI="https://github.com/ch1bo/flycheck-clang-tidy/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=app-emacs/flycheck-0.30
"
RDEPEND="
	${BDEPEND}
"

SITEFILE="50${PN}-gentoo.el"
