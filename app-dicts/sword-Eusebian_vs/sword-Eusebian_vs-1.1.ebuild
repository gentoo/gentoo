# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SWORD_MINIMUM_VERSION="1.5.9"

inherit sword-module

DESCRIPTION="Eusebian Numbers By Verse"
HOMEPAGE="https://crosswire.org/sword/modules/ModInfo.jsp?modName=Eusebian_vs"
LICENSE="public-domain"
KEYWORDS="~amd64 ~loong ~ppc ~riscv ~x86"

RDEPEND="!app-dicts/sword-Eusebian_num"
