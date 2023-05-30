# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
GST_ORG_MODULE=gst-plugins-bad
GST_PLUGINS_ENABLED="va"
inherit gstreamer-meson python-any-r1

DESCRIPTION="Hardware accelerated video decoding through VA-API plugin for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
SLOT="1.0"
KEYWORDS="~amd64"
IUSE="+introspection +orc"

# Baseline requirement for libva is 1.6, but 1.10 gets more features
RDEPEND="
	>=media-libs/libva-1.10[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	orc? ( >=dev-lang/orc-0.4.33[${MULTILIB_USEDEP}] )
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-bad-${PV}:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
"
