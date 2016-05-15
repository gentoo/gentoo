# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: vmware-bundle.eclass
# @MAINTAINER:
# vmware@gentoo.org
# @AUTHOR:
# Matt Whitlock <matt@whitlock.name>
# @BLURB: Provides extract functionality for vmware products bundles

DEPEND="dev-libs/libxslt"

vmware-bundle_extract-bundle-component() {
	local bundle=${1:?} component=${2:?} dest=${3:-${2}}
	cat > "${T}"/list-bundle-components.xsl <<-EOF
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output omit-xml-declaration="yes"/>
			<xsl:template match="text()"/>
			<xsl:template match="/bundle/components/component">
				<xsl:value-of select="@offset"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@size"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:template>
		</xsl:stylesheet>
		EOF
	local -i bundle_size=$(stat -L -c'%s' "${bundle}")
	local -i bundle_manifestOffset=$(od -An -j$((bundle_size-36)) -N4 -tu4 "${bundle}")
	local -i bundle_manifestSize=$(od -An -j$((bundle_size-40)) -N4 -tu4 "${bundle}")
	local -i bundle_dataOffset=$(od -An -j$((bundle_size-44)) -N4 -tu4 "${bundle}")
	local -i bundle_dataSize=$(od -An -j$((bundle_size-52)) -N8 -tu8 "${bundle}")
	tail -c+$((bundle_manifestOffset+1)) "${bundle}" 2> /dev/null | head -c$((bundle_manifestSize)) |
		xsltproc "${T}"/list-bundle-components.xsl - |
		while read -r component_offset component_size component_name ; do
			if [[ ${component_name} == ${component} ]] ; then
				ebegin "Extracting '${component_name}' component from '$(basename "${bundle}")'"
				vmware-bundle_extract-component "${bundle}" "${dest}" $((bundle_dataOffset+component_offset))
				eend
			fi
		done
}

vmware-bundle_extract-component() {
	local component=${1:?} dest=${2:-.}
	local -i offset=${3}
	cat > "${T}"/list-component-files.xsl <<-EOF
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output omit-xml-declaration="yes"/>
			<xsl:template match="text()"/>
			<xsl:template match="/component/fileset/file">
				<xsl:value-of select="@offset"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@compressedSize"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@uncompressedSize"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@path"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:template>
		</xsl:stylesheet>
		EOF
	local -i component_manifestOffset=$(od -An -j$((offset+9)) -N4 -tu4 "${component}")
	local -i component_manifestSize=$(od -An -j$((offset+13)) -N4 -tu4 "${component}")
	local -i component_dataOffset=$(od -An -j$((offset+17)) -N4 -tu4 "${component}")
	local -i component_dataSize=$(od -An -j$((offset+21)) -N8 -tu8 "${component}")
	tail -c+$((offset+component_manifestOffset+1)) "${component}" 2> /dev/null |
		head -c$((component_manifestSize)) | xsltproc "${T}"/list-component-files.xsl - |
		while read -r file_offset file_compressedSize file_uncompressedSize file_path ; do
			if [[ ${file_path} ]] ; then
				file_path="${dest}/${file_path}"
				mkdir -p "$(dirname "${file_path}")" || die
				if [[ ${file_compressedSize} -gt 0 ]] ; then
					echo -n '.'
					tail -c+$((offset+component_dataOffset+file_offset+1)) "${component}" 2> /dev/null |
						head -c$((file_compressedSize)) | gzip -cd > "${file_path}" || die
				else
					echo -n 'x'
				fi
			fi
		done
	echo
}
