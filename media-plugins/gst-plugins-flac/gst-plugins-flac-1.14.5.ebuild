# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPTION="FLAC encoder/decoder/tagger plugin for GStreamer"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
