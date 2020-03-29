# Copyright 2010-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="ssl"
DISTUTILS_USE_SETUPTOOLS=rdepend

EGIT_BRANCH="master"
if [[ ${PV} == *999* ]]; then
	[[ ${PV} == 9998 ]] && EGIT_BRANCH="stable"
	GIT_SCM=git-r3
	SRC_URI=""
else
	GITLAB_ID="7b91875f693b60e93c5976daa051034b"
	SRC_URI="https://git.weboob.org/${PN}/${PN}/uploads/${GITLAB_ID}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

EGIT_REPO_URI="https://git.weboob.org/${PN}/${PN}.git"
inherit distutils-r1 ${GIT_SCM}
unset GIT_SCM

DESCRIPTION="Consume lots of websites without a browser (Web Outside Of Browsers)"
HOMEPAGE="http://weboob.org/"

LICENSE="LGPL-3+"
SLOT="0"
IUSE="fast-libs +secure-updates"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/html2text[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP},ssl]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	fast-libs? (
		dev-python/pyyaml[libyaml,${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
	)
	secure-updates? ( app-crypt/gnupg )
"
DEPEND="${RDEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/${PN}/
	doins -r contrib
}
