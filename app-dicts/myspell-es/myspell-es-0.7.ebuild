# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# yay for modern download tools like redmine and their unique IDs as part of
# the URL - this means that someone needs to check the download page if there
# are new releases:
#	http://forja.rediris.es/frs/?group_id=341
# When checking ensure you update id above as well as the order of MUTATIONS if
# necessary.
MUTATIONS="es_ANY es_VE es_UY es_SV es_PY es_PR es_PE es_PA es_NI es_MX es_HN
es_GT es_ES es_EC es_DO es_CU es_CR es_CO es_CL es_BO es_AR"
d_id=2933

MYSPELL_DICT=( )
MYSPELL_HYPH=(
	"hyph_es_ANY.dic"
)
MYSPELL_THES=(
	"th_es_ES_v2.dat"
	"th_es_ES_v2.idx"
)

SRC_URI=""
for i in ${MUTATIONS}; do
	MYSPELL_DICT+=(
		"${i}.dic"
		"${i}.aff"
	)
	SRC_URI+=" http://forja.rediris.es/frs/download.php/${d_id}/${i}.oxt -> ${i}-${PV}.oxt"
	let d_id=${d_id}+1
done
unset i d_id

inherit myspell-r2

DESCRIPTION="Spanish dictionaries for myspell/hunspell"
HOMEPAGE="http://rla-es.forja.rediris.es/"
LICENSE="GPL-3 LGPL-3 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

src_prepare() {
	# remove license files
	rm -rf {GPL,LGPL,MPL}*
	default
}
