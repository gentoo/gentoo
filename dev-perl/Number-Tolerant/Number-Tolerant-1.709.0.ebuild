# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="RJBS"
DIST_VERSION="1.709"

inherit perl-module

DESCRIPTION="Test routines for testing numbers against tolerances"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Sub-Exporter-0.988.0"

BDEPEND="${RDEPEND}"
