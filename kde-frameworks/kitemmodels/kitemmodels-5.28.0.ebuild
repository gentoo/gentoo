# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing data models to help with tasks such as sorting and filtering"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="test? ( $(add_qt_dep qtwidgets) )"
