# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Python high-level interface and ctypes-based bindings for PulseAudio (libpulse)"
HOMEPAGE="
	https://github.com/mk-fg/python-pulse-control/
	https://pypi.org/project/pulsectl/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	media-libs/libpulse
"
# https://github.com/mk-fg/python-pulse-control/issues/77
BDEPEND="
	test? (
		media-sound/pulseaudio-daemon
	)
"

distutils_enable_tests unittest
