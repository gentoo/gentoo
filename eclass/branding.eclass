# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: branding.eclass
# @MAINTAINER:
# James Le Cuirot <chewi@gentoo.org>
# @AUTHOR:
# James Le Cuirot <chewi@gentoo.org>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Branding variables with Gentoo defaults
# @DESCRIPTION:
# This defines a set of variables for applying branding to various packages. The
# variables default to Gentoo values. These can be overridden by downstream
# distributions.

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: BRANDING_OS_NAME
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Corresponds to os-release's NAME. See os-release(5).
: "${BRANDING_OS_NAME:=Gentoo}"

# @ECLASS_VARIABLE: BRANDING_OS_ID
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Corresponds to os-release's ID. See os-release(5). This variable has strict
# formatting requirements.
: "${BRANDING_OS_ID:=gentoo}"

# @ECLASS_VARIABLE: BRANDING_OS_ID_LIKE
# @OUTPUT_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Corresponds to os-release's ID_LIKE. See os-release(5).

# @ECLASS_VARIABLE: BRANDING_OS_HOME_URL
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Corresponds to os-release's HOME_URL. See os-release(5).
: "${BRANDING_OS_HOME_URL:=https://www.gentoo.org/}"

# @ECLASS_VARIABLE: BRANDING_OS_SUPPORT_URL
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Corresponds to os-release's SUPPORT_URL. See os-release(5).
: "${BRANDING_OS_SUPPORT_URL:=https://www.gentoo.org/support/}"

# @ECLASS_VARIABLE: BRANDING_OS_BUG_REPORT_URL
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Corresponds to os-release's BUG_REPORT_URL. See os-release(5).
: "${BRANDING_OS_BUG_REPORT_URL:=https://bugs.gentoo.org/}"

# @ECLASS_VARIABLE: BRANDING_OS_VERSION
# @OUTPUT_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Corresponds to os-release's VERSION. See os-release(5). This is typically set
# by sys-apps/baselayout to PV when creating /etc/os-release. As such, it is not
# readable by other packages unless overridden globally, but baselayout's PV has
# little relevance to other packages anyway.

# @ECLASS_VARIABLE: BRANDING_OS_VERSION_ID
# @OUTPUT_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Corresponds to os-release's VERSION_ID. See os-release(5). This variable has
# strict formatting requirements. Like BRANDING_OS_VERSION above, this is also
# set by baselayout to PV.

# @ECLASS_VARIABLE: BRANDING_OS_PRETTY_NAME
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Corresponds to os-release's PRETTY_NAME. See os-release(5). If completely
# unset, defaults to "Gentoo Linux". If set but blank, defaults to the
# concatenation of BRANDING_OS_NAME and BRANDING_OS_VERSION.
: "${BRANDING_OS_PRETTY_NAME=Gentoo Linux}"
: "${BRANDING_OS_PRETTY_NAME:=${BRANDING_OS_NAME}${BRANDING_OS_VERSION:+ }${BRANDING_OS_VERSION}}"

# These variables are recognised by GNU's version-etc.m4.
export with_packager="${BRANDING_OS_NAME}"
export with_packager_bug_reports="${BRANDING_OS_BUG_REPORT_URL}"
export with_packager_version="${PVR}"
