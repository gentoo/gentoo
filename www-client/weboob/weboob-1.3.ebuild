# Copyright 2010-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl"

EGIT_BASE="devel"
if [[ ${PV} == *999* ]]; then
	[[ ${PV} == 9998 ]] && EGIT_BASE="stable"
	GIT_SCM=git-r3
	SRC_URI=""
else
	REDMINE_ID="356"
	SRC_URI="https://symlink.me/attachments/download/${REDMINE_ID}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

EGIT_REPO_URI="https://git.weboob.org/${PN}/${EGIT_BASE}.git"
inherit distutils-r1 gnome2-utils ${GIT_SCM}
unset EGIT_BASE GIT_SCM

DESCRIPTION="Consume lots of websites without a browser (Web Outside Of Browsers)"
HOMEPAGE="http://weboob.org/"

LICENSE="AGPL-3"
SLOT="0"
IUSE="+deprecated fast-libs +secure-updates X"

COMMON_DEPEND="
	X? ( dev-python/PyQt5[multimedia,${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
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
	virtual/python-futures[${PYTHON_USEDEP}]
	deprecated? ( dev-python/mechanize[${PYTHON_USEDEP}] )
	fast-libs? (
		dev-python/pyyaml[libyaml,${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
	)
	secure-updates? ( app-crypt/gnupg )
	X? ( dev-python/google-api-python-client[${PYTHON_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	default

	if [[ -L contrib/webextension-session-importer/logo.png ]]; then
		cp -L contrib/webextension-session-importer/logo.png logo.tmp.png || die
		rm contrib/webextension-session-importer/logo.png || die
		mv logo.tmp.png contrib/webextension-session-importer/logo.png || die
	fi
}

python_configure_all() {
	mydistutilsargs=(
		$(usex X '--qt' '--no-qt')
		$(usex X '--xdg' '--no-xdg')
	)
}

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/${PN}/
	doins -r contrib
}

pkg_preinst() {
	use X && gnome2_icon_savelist
}

pkg_postinst() {
	use X && gnome2_icon_cache_update
	elog 'You should now run "weboob-config update" (as your login user).'
}

pkg_postrm() {
	use X && gnome2_icon_cache_update
}
