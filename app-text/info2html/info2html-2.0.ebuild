# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils webapp

DESCRIPTION="Converts GNU .info files to HTML"
HOMEPAGE="http://info2html.sourceforge.net/"
SRC_URI="mirror://sourceforge/info2html/${P}.tar"

LICENSE="freedist"
# webapp.eclass deals with SLOTting
#SLOT="0"
IUSE=""
KEYWORDS="alpha amd64 hppa sparc x86"

RDEPEND="dev-lang/perl"

src_unpack() {
	local infos state line i
	unpack ${A}
	cd ${S}

	# filter user-provided data to prevent cross-frame/site scripting attacks
	# bug #91354 (fix from Werner Fink)
	epatch ${FILESDIR}/info2html-2.0-xss.patch

	# Fixup INFODIR for paths in /etc/profile.env INFOPATH
	infos=$(grep "^export INFOPATH=" /etc/profile.env | tail -n 1 |\
				sed -e "s:^export INFOPATH=:INFOPATH=:;s:'::g")
	# Default path to /usr/share/info and /usr/local/share/info
	[[ -z ${infos} ]] && export infos="/usr/share/info"
	infos=( ${INFOPATH//:/ } )
	mv ${S}/info2html.conf ${S}/info2html.conf.orig
	touch ${S}/info2html.conf
	state="copy"
	inserted="no"
	while read line; do
		[[ ${line} == "@INFODIR = (" ]] && state="insert"
		[[ ${line} == ");" ]] && state="copy"
		case ${state} in
			"copy")
				echo ${line} >> ${S}/info2html.conf
				;;
			"insert")
				echo ${line} >> ${S}/info2html.conf
				for info in "${infos[@]}"; do
					echo "	'${info}'," >> ${S}/info2html.conf
				done
				echo "	'/usr/local/share/info'" >> ${S}/info2html.conf
				state="skip"
				inserted="yes"
				;;
			"skip")
				;;
		esac
	done < ${S}/info2html.conf.orig
	[[ ${state} == "copy" && ${inserted} == "yes" ]] ||
		die "Setting up info2html.conf failed"
}

src_install() {
	webapp_src_preinst

	exeinto ${MY_CGIBINDIR}
	cp info2html infocat info2html.css info2html.conf ${D}/${MY_CGIBINDIR}
	# README zapped by info2html-gentoo.patch; it only listed
	# the homepage so it doesn't add anything useful.
	# dodoc README

	webapp_src_install
}
