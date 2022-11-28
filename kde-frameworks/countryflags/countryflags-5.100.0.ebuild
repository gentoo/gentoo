# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="false"
KDE_ORG_NAME="kdelibs4support"
inherit ecm frameworks.kde.org

DESCRIPTION="Icons of flags for various countries"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

CMAKE_USE_DIR="${S}/src/l10n"

# https://phabricator.kde.org/T13722
# https://invent.kde.org/frameworks/breeze-icons/-/issues/1
PATCHES=( "${FILESDIR}/${PN}-5.90.0-standalone.patch" )

RDEPEND="!<kde-frameworks/kdelibs4support-5.90.0:5"
