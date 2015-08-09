# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_DOC_DIRS="doc-translations/%lingua_${PN}"
KDE_HANDBOOK="optional"
KDE_LINGUAS="ca cs da de en_GB es et lt nl pl pt pt_BR sk sv uk"
MY_P="SymbolEditor-${PV}"
inherit kde4-base

DESCRIPTION="Program to create libraries of QPainterPath objects with hints on how to render them"
HOMEPAGE="http://userbase.kde.org/SymbolEditor"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${MY_P}-1.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="sys-devel/gettext"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-cflags.patch" )
