# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/heroes3/heroes3-1.3.1a-r2.ebuild,v 1.18 2015/04/29 05:22:05 mr_bones_ Exp $

#	[x] Base Install Required (+4 MB)
#	[x] Scenarios (+7 MB)
#	[x] Sounds and Graphics (+118 MB)
#	[x] Music (+65 MB)
#	[x] Videos (+147 MB)
#	--------------------
#	Total 341 MB

EAPI=5
LANGS="de es pl"
LANGPACKPREFIX="${PN}-lang"
LANGPACKBASE="http://babelize.org/download/"
LANGPACKPATHPREFIX="${LANGPACKBASE}/${LANGPACKPREFIX}"
LANGPACKVERSION=1.0.4

inherit eutils unpacker cdrom games

DESCRIPTION="Heroes of Might and Magic III : The Restoration of Erathia - turn-based 2-D medieval combat"
HOMEPAGE="http://www.lokigames.com/products/heroes3/"

# Since I do not have a PPC machine to test with, I will leave the PPC stuff in
# here so someone else can stabilize loki_setupdb and loki_patch for PPC and
# then KEYWORD this appropriately.
SRC_URI="x86? ( mirror://lokigames/${PN}/${P}-cdrom-x86.run )
	amd64? ( mirror://lokigames/${PN}/${P}-cdrom-x86.run )
	ppc? ( mirror://lokigames/${PN}/${P}-ppc.run )"
# This is commented because the server is unreachable.
#	linguas_es? ( ${LANGPACKPATHPREFIX}-es.tar.gz )
#	linguas_de? ( ${LANGPACKPATHPREFIX}-de.tar.gz )
#	linguas_pl? ( ${LANGPACKPATHPREFIX}-pl.tar.gz )"

#		${LANGPACKBASE}/${PN}-localize-${LANGPACKVERSION}.run

LICENSE="LOKI-EULA"
SLOT="0"
IUSE="nocd maps music sounds videos"
#linguas_en linguas_es linguas_pl linguas_de"
KEYWORDS="~amd64 ~ppc x86"
RESTRICT="strip"

DEPEND="=dev-util/xdelta-1*
	games-util/loki_patch"
RDEPEND="!ppc? ( sys-libs/lib-compat-loki )"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

pkg_setup() {
	games_pkg_setup
#	strip-linguas en ${LANGS}

	use nocd && fullinstall=1
	use sounds && use videos && use maps && fullinstall=1

	[[ ${fullinstall} -eq 1 ]] \
		&& ewarn "The full installation takes about 341 MB of space!"

#	if [[ -n "${fullinstall}" ]]
#	then
#		langcount=0
#		for i in ${LINGUAS}
#		do
#			i="${i/_/-}"
#			if [[ ${i} != "en" ]]
#			then
#				let $((++langcount))
#				if [[ $langcount = 2 ]]
#				then
#					eerror "Heroes3 only supports one localization at once!"
#					die "Localization is only supported when Heroes3 is in a single language!"
#				fi
#			fi
#		done
#	else
#		for i in ${LINGUAS}
#		do
#			i="${i/_/-}"
#			if [[ ${i} != "en" ]]
#			then
#				eerror "Full installation (nocd flag or data + video + maps flags) is needed for ${i} language!"
#				die "Localization is only supported when Heroes3 is fully locally installed!"
#			fi
#		done
#	fi
}

src_unpack() {
	cdrom_get_cds hiscore.tar.gz
	(use x86 || use amd64) && unpack_makeself ${P}-cdrom-x86.run
	use ppc && unpack_makeself ${P}-ppc.run

#	for i in ${LINGUAS}
#	do
#		i="${i/_/-}"
#		if [[ ${i} != "en" ]]
#		then
#			mkdir localize
#			cd localize
##			unpack_makeself ${PN}-localize-${LANGPACKVERSION}.run
#			unpack ${LANGPACKPREFIX}-${i}.tar.gz
#			break
#		fi
#	done
}

src_install() {
	exeinto "${dir}"
	insinto "${dir}"
	einfo "Copying files... this may take a while..."
	doexe "${CDROM_ROOT}"/bin/x86/${PN}
	doins "${CDROM_ROOT}"/{Heroes_III_Tutorial.pdf,README,icon.{bmp,xpm}}

	if use nocd
	then
		doins -r "${CDROM_ROOT}"/{data,maps,mp3}
	else
		if use maps
		then
			doins -r "${CDROM_ROOT}"/maps
		fi
		if use music
		then
			doins -r "${CDROM_ROOT}"/mp3
		fi
		if use sounds
		then
			insinto "${dir}"/data
			doins "${CDROM_ROOT}"/data/{*.lod,*.snd}
		fi
		if use videos
		then
			doins -r "${CDROM_ROOT}"/data/video
		fi
	fi

#	if [[ -n "${fullinstall}" ]]
#	then
#		for i in ${LINGUAS}
#		do
#			i="${i/_/-}"
#			if [[ ${i} != "en" ]]
#			then
#				find "${S}/localize/${i}" -type f | while read xfile
#				do
#					local file=$(echo "${xfile}" | \
#						sed "s#^${S}/localize/${i}/##;s#\.xdelta\$##")
#					ebegin "Localizing ${file}"
#					xdelta patch "${xfile}" "${Ddir}/${file}" "${Ddir}/${file}.xdp"
#					local retval=$?
#					if [[ $retval = 0 ]]
#					then
#						mv -f  "${Ddir}/${file}.xdp" "${Ddir}/${file}"
#					else
#						rm -f "${Ddir}/${file}.xdp"
#					fi
#					eend $retval "File $file could not be localized/patched! Original english version untouched..."
#				done
#				break
#			fi
#		done
#	fi

	tar zxf "${CDROM_ROOT}"/hiscore.tar.gz -C "${Ddir}" || die

	cd "${S}"
	loki_patch --verify patch.dat
	loki_patch patch.dat "${Ddir}" >& /dev/null || die

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' \;

	newicon "${CDROM_ROOT}"/icon.xpm heroes3.xpm

	prepgamesdirs
	make_desktop_entry heroes3 "Heroes of Might and Magic III" "heroes3"

	if ! use ppc
	then
		einfo "Linking libs provided by 'sys-libs/lib-compat-loki' to '${dir}'."
		dosym /lib/loki_ld-linux.so.2 "${dir}"/ld-linux.so.2
		dosym /usr/lib/loki_libc.so.6 "${dir}"/libc.so.6
		dosym /usr/lib/loki_libnss_files.so.2 "${dir}"/libnss_files.so.2
	fi

	elog "Changing 'hiscore.dat' to be writeable for group 'games'."
	fperms g+w "${dir}/data/hiscore.dat"

	# in order to play campaign games, put this wrapper in place.
	# it changes CWD to a user-writeable directory before executing heroes3.
	# (fixes bug #93604)
	einfo "Preparing wrapper."
	cp "${FILESDIR}"/heroes3-wrapper.sh "${T}"/heroes3 || die
	sed -i -e "s:GAMES_PREFIX_OPT:${GAMES_PREFIX_OPT}:" "${T}"/heroes3 || die
	dogamesbin "${T}"/heroes3
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the game run:"
	elog " heroes3"
}
