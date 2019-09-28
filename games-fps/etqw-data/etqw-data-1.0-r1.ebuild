# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cdrom

DESCRIPTION="Enemy Territory: Quake Wars data files"
HOMEPAGE="http://zerowing.idsoftware.com/linux/etqw/ETQWFrontPage/"
SRC_URI=""

LICENSE="ETQW"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="videos"
RESTRICT="bindist"

S="${WORKDIR}"

src_install() {
	local dir=/opt/etqw

	cdrom_get_cds Setup/Data/base/DEU:Setup/Data/base/POL:Setup/Data/base

	cd "${CDROM_ROOT}"/Setup/Data/base
	insinto "${dir}"/base
	doins pak00{0..4}.pk4
	doins -r megatextures

	case ${CDROM_SET} in
		0)
			doins \
				zpak_english000.pk4 \
				DEU/zpak_german000.pk4 \
				ESP/zpak_spanish000.pk4 \
				FRA/zpak_french000.pk4
			;;
		1)
			doins \
				POL/zpak_polish000.pk4 \
				RUS/zpak_russian000.pk4
			;;
		2)
			doins zpak_english000.pk4
			;;
	esac

	if use videos ; then
		case ${CDROM_SET} in
			0|2)
				doins -r video
				;;
		esac
	fi
}
