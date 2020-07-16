# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit vim-plugin python-r1

DESCRIPTION="vim plugin: tab-complete your Python code"
HOMEPAGE="https://rkulla.github.io/pydiction/"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.zip"

LICENSE="vim"
KEYWORDS="amd64 ppc ppc64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="app-arch/unzip"
RDEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-master"

src_install() {
	# Rename pydiction script.
	mv "${PN}.py" "${PN}" || die

	# We're going to remove those files in a second
	# otherwise they're installed by Portage.
	local pyfiles=( complete-dict "${PN}" )
	insinto "/usr/share/${P}"
	doins complete-dict

	# pydiction is treated a singular script that lives on its own.
	python_foreach_impl python_doscript "${PN}"
	rm -v "${pyfiles[@]}" || die

	vim-plugin_src_install
}
