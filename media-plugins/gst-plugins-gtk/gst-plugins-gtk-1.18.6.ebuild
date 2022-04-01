# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Video sink plugin for GStreamer that renders to a GtkWidget"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+egl gles2 +opengl wayland +X" # Keep default IUSE mirrored with gst-plugins-base
# egl, wayland and X only matters if gst-plugins-base is built with USE=opengl and/or USE=gles2
# We mirror egl/gles2/opengl/wayland/X due to automagic detection from gstreamer-gl.pc variables;
# we don't care about matching egl/wayland/X if both opengl and gles2 are disabled here and on
# gst-plugins-base, but no way to express that.

# We only need gtk+ matching backend flags when GL is enabled
GL_DEPS="
	>=x11-libs/gtk+-3.15:3[X?,wayland?,${MULTILIB_USEDEP}]
"
RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},egl=,gles2=,opengl=,wayland=,X=]
	>=x11-libs/gtk+-3.15:3[${MULTILIB_USEDEP}]
	gles2? ( ${GL_DEPS} )
	opengl? ( ${GL_DEPS} )

	!<media-libs/gst-plugins-bad-1.13.1:1.0
"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="gtk3"
