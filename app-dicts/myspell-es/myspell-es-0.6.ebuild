# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-es/myspell-es-0.6.ebuild,v 1.2 2012/06/13 14:45:25 mr_bones_ Exp $

EAPI=4

MUTATIONS="es_ANY es_AR es_BO es_CL es_CO es_CR es_CU es_DO es_EC es_ES es_GT
es_HN es_MX es_NI es_PA es_PE es_PR es_SV es_UY es_VE"

MYSPELL_DICT=( )
MYSPELL_HYPH=(
	"hyph_es_ANY.dic"
)
MYSPELL_THES=(
	"th_es_ES_v2.dat"
	"th_es_ES_v2.idx"
)
SRC_URI=""
j=2618
for i in ${MUTATIONS}; do
	MYSPELL_DICT+=(
		"${i}.dic"
		"${i}.aff"
	)
	SRC_URI+=" http://forja.rediris.es/frs/download.php/${j}/${i}.oxt -> ${i}-${PV}.oxt"
	let j=${j}+1
done
unset i j

inherit myspell-r2

DESCRIPTION="Spanish dictionaries for myspell/hunspell"
HOMEPAGE="http://rla-es.forja.rediris.es/"
# yay for modern download tools like redmine and their unique IDs as part of URL
# this means that someone needs to check the download page if there are new releases:
#	http://forja.rediris.es/frs/?group_id=341

LICENSE="GPL-3 LGPL-3 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

src_prepare() {
	# remove license files
	rm -rf {GPL,LGPL,MPL}*
}
