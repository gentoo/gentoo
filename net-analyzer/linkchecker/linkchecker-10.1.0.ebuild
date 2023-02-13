# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
PYTHON_REQ_USE="sqlite?"

inherit bash-completion-r1 distutils-r1 optfeature

DESCRIPTION="Check websites for broken links"
HOMEPAGE="https://github.com/linkcheck/linkchecker"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/linkcheck/linkchecker.git"
	inherit git-r3
else
	SRC_URI="https://github.com/linkchecker/linkchecker/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="sqlite"
# requires libs not present in portage yet
RESTRICT="test"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-9.3-bash-completion.patch"
	"${FILESDIR}/${PN}-10.1.0-version.patch"
)

DOCS=(
	doc/changelog.txt
	doc/upgrading.txt
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e "s/LINKCHECKER_VERSION/${PV}/g" -i setup.py || die
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp config/linkchecker-completion ${PN}
}

pkg_postinst() {
	optfeature "bash-completion support" dev-python/argcomplete[${PYTHON_USEDEP}]
	optfeature "Virus scanning" app-antivirus/clamav
	optfeature "GNOME proxy settings support" dev-python/pygobject[${PYTHON_USEDEP}]
}
