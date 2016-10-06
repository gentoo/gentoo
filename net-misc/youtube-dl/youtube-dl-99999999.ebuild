# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(python{2_7,3_3,3_4,3_5})
inherit bash-completion-r1 distutils-r1 eutils git-r3

DESCRIPTION="Download videos from YouTube.com (and more sites...)"
HOMEPAGE="https://rg3.github.com/youtube-dl/"
EGIT_REPO_URI="https://github.com/rg3/youtube-dl.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE="offensive test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? ( dev-python/nose[coverage(+)] )
"

python_prepare_all() {
	if ! use offensive; then
		sed -i -e "/__version__/s|'$|-gentoo_no_offensive_sites'|g" \
			youtube_dl/version.py || die
		# these have single line import statements
		local xxx=(
			alphaporno anysex behindkink camwithher chaturbate drtuber eporner
			eroprofile extremetube fourtube foxgay goshgay hellporno
			hentaistigma hornbunny keezmovies lovehomeporn mofosex motherless
			myvidster porn91 pornhd pornotube pornovoisines pornoxo redtube
			ruleporn sexu slutload spankbang spankwire sunporno thisav tube8
			vporn watchindianporn xbef xnxx xtube xvideos xxxymovies youjizz
			youporn
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

	epatch_user

	distutils-r1_python_prepare_all
}

src_compile() {
	distutils-r1_src_compile
}

python_test() {
	emake test
}

python_install_all() {
	dodoc README.md

	distutils-r1_python_install_all

	rm -r "${ED}"/usr/etc || die
}
