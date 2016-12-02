# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Download videos from YouTube.com (and more sites...)"
HOMEPAGE="https://rg3.github.com/youtube-dl/"
SRC_URI="http://youtube-dl.org/downloads/${PV}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="offensive test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[coverage(+)] )
"

S="${WORKDIR}/${PN}"

python_prepare_all() {
	if ! use offensive; then
		sed -i -e "/__version__/s|'$|-gentoo_no_offensive_sites'|g" \
			youtube_dl/version.py || die
		# these have single line import statements
		local xxx=(
			alphaporno anysex behindkink camwithher chaturbate drtuber eporner
			eroprofile extremetube fourtube foxgay goshgay hellporno
			hentaistigma hornbunny keezmovies lovehomeporn malemotion mofosex
			motherless myvidster porn91 pornhd pornotube pornovoisines pornoxo
			redtube ruleporn sexu sexykarma slutload spankbang spankwire
			sunporno thisav trutube tube8 vporn xbef xnxx xtube xvideos
			xxxymovies youjizz youporn
		)
		# these have multi-line import statements
		local mxxx=(
			pornhub xhamster tnaflix
		)
		# do single line imports
		sed -i \
			-e $( printf '/%s/d;' ${xxx[@]} ) \
			youtube_dl/extractor/extractors.py \
			|| die

		# do multiple line imports
		sed -i \
			-e $( printf '/%s/,/)/d;' ${mxxx[@]} ) \
			youtube_dl/extractor/extractors.py \
			|| die

		sed -i \
			-e $( printf '/%s/d;' ${mxxx[@]} ) \
			youtube_dl/extractor/generic.py \
			|| die

		rm \
			$( printf 'youtube_dl/extractor/%s.py ' ${xxx[@]} ) \
			$( printf 'youtube_dl/extractor/%s.py ' ${mxxx[@]} ) \
			test/test_age_restriction.py \
			|| die
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	emake test
}

python_install_all() {
	python_domodule youtube_dl
	dobin bin/${PN}

	dodoc README.txt
	doman ${PN}.1

	newbashcomp ${PN}.bash-completion ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}.zsh

	distutils-r1_python_install_all
}
