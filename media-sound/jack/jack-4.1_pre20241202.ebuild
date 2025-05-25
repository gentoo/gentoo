# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="ncurses"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A frontend for several cd-rippers and mp3 encoders"
HOMEPAGE="https://github.com/jack-cli-cd-ripper/jack https://www.home.unix-ag.org/arne/jack/"
GIT_COMMIT_HASH="3410dc12a034b2331e53002f93a1716ec74e5a92" # branch "python3-mb"
GIT_DOC_HASH="4303994b67222639ee4c3f55b214020b2f5c75f4"
SRC_URI="
	https://github.com/jack-cli-cd-ripper/jack/archive/${GIT_COMMIT_HASH}.tar.gz -> ${P}.tar.gz
	https://github.com/jack-cli-cd-ripper/jack/raw/${GIT_DOC_HASH}/example.etc.jackrc
		-> example.etc.jackrc-4.1_pre20230723
	https://github.com/jack-cli-cd-ripper/jack/raw/${GIT_DOC_HASH}/jack.man
		-> jack.man-4.1_pre20230723
"
S="${WORKDIR}/${PN}-${GIT_COMMIT_HASH}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
	')"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/discid[${PYTHON_USEDEP}]
		media-libs/mutagen[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	media-libs/flac
	media-sound/cdparanoia
	media-sound/lame"

python_prepare_all() {
	distutils-r1_python_prepare_all
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_install_all() {
	insinto /etc
	newins "${DISTDIR}/example.etc.jackrc-4.1_pre20230723" jackrc

	newman "${DISTDIR}/jack.man-4.1_pre20230723" jack.1

	local DOCS=( doc/README.md doc/CHANGELOG )
	local HTML_DOCS=( doc/*.{html,css,gif} )
	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "${PN} can use the following optional binaries, but currently there"
	elog "are no gentoo ebuilds available for them:"
	elog "  fdkaac: encode to M4A format"
	elog "  oggenc: encode to OGG format"
	elog "  cdda2wav / dagrab / tosha: cd ripper"
}
