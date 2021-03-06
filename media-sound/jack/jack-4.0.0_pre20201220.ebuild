# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="ncurses"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A frontend for several cd-rippers and mp3 encoders"
HOMEPAGE="https://github.com/jack-cli-cd-ripper/jack http://www.home.unix-ag.org/arne/jack/"
GIT_COMMIT_HASH="5f3e5f43f476b0d506144c103eb8d4edf76fc5de" # branch "python3-mb"
SRC_URI="https://github.com/jack-cli-cd-ripper/jack/archive/${GIT_COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_COMMIT_HASH}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/python-discid[${PYTHON_MULTI_USEDEP}]
		media-libs/mutagen[${PYTHON_MULTI_USEDEP}]
	')
	media-libs/flac
	media-sound/cdparanoia
	media-sound/lame"

python_install_all() {
	insinto /etc
	newins example.etc.jackrc jackrc

	newman jack.man jack.1

	local DOCS=( README.md CHANGELOG.md )
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
