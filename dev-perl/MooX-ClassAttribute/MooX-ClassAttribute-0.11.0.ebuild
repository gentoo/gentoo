# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TOBYINK"
DIST_VERSION="0.011"

inherit perl-module

DESCRIPTION="declare class attributes Moose-style... but without Moose"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Exporter-Tiny
	dev-perl/Moo
	dev-perl/Role-Tiny"

BDEPEND="${RDEPEND}"
