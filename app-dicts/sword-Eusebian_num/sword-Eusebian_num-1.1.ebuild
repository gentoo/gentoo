# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SWORD_MINIMUM_VERSION="1.5.1a"

inherit sword-module

DESCRIPTION="Eusebian Numbers"
HOMEPAGE="https://crosswire.org/sword/modules/ModInfo.jsp?modName=Eusebian_num"
LICENSE="public-domain"
KEYWORDS="~amd64 ~loong ~ppc ~riscv ~x86"

RDEPEND="!app-dicts/sword-Eusebian_vs"
