# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-officeext/sun-templates/sun-templates-1.0.0-r1.ebuild,v 1.4 2014/08/10 18:18:38 slyfox Exp $

EAPI=5

OFFICE_EXTENSIONS=(
	"472ffb92d82cf502be039203c606643d-Sun-ODF-Template-Pack-en-US_${PV}.oxt"
	"53ca5e56ccd4cab3693ad32c6bd13343-Sun-ODF-Template-Pack-de_${PV}.oxt"
	"4ad003e7bbda5715f5f38fde1f707af2-Sun-ODF-Template-Pack-es_${PV}.oxt"
	"a53080dc876edcddb26eb4c3c7537469-Sun-ODF-Template-Pack-fr_${PV}.oxt"
	"09ec2dac030e1dcd5ef7fa1692691dc0-Sun-ODF-Template-Pack-hu_${PV}.oxt"
	"b33775feda3bcf823cad7ac361fd49a6-Sun-ODF-Template-Pack-it_${PV}.oxt"
)
URI_EXTENSIONS="${OFFICE_EXTENSIONS[@]/#/http://ooo.itc.hu/oxygenoffice/download/libreoffice/}"

inherit office-ext-r1

DESCRIPTION="Collection of sun templates for various countries"
HOMEPAGE="http://ooo.itc.hu/oxygenoffice/download/libreoffice/"
SRC_URI="${URI_EXTENSIONS}"

LICENSE="sun-bcla-j2me"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
