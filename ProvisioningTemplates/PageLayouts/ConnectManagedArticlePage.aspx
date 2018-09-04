<%@ Page language="C#"   Inherits="Microsoft.SharePoint.Publishing.PublishingLayoutPage,Microsoft.SharePoint.Publishing,Version=15.0.0.0,Culture=neutral,PublicKeyToken=71e9bce111e9429c" meta:progid="SharePoint.WebPartPage.Document" %>
<%@ Register Tagprefix="SharePointWebControls" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="PublishingWebControls" Namespace="Microsoft.SharePoint.Publishing.WebControls" Assembly="Microsoft.SharePoint.Publishing, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="PublishingNavigation" Namespace="Microsoft.SharePoint.Publishing.Navigation" Assembly="Microsoft.SharePoint.Publishing, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePointPortalControls" Namespace="Microsoft.SharePoint.Portal.WebControls" Assembly="Microsoft.SharePoint.Portal, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register tagprefix="WebControls" namespace="Microsoft.Office.Server.Search.WebControls" assembly="Microsoft.Office.Server.Search, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Taxonomy" Namespace="Microsoft.SharePoint.Taxonomy" Assembly="Microsoft.SharePoint.Taxonomy, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<asp:Content ContentPlaceholderID="PlaceHolderAdditionalPageHead" runat="server">
	<SharePointWebControls:CssRegistration name="<% $SPUrl:~sitecollection/Style Library/~language/Themable/Core Styles/pagelayouts15.css %>" runat="server"/>
	<link id="CSS1" href="<% $SPUrl:~SiteCollection/_catalogs/masterpage/enhancements/css_babcockintranets.css?v=5%>" runat="server" type="text/css" rel="stylesheet" />
	<style type="text/css">
	/*Styles specific to page template*/
	
	#contentBox {
	  margin-right:0; /*Removed due to web part zone*/
	}
		
	/*Styles specific to pages where title is shown as a banner */

	/*End Specific Styles for page layout*/
	
	</style>
	<script language="javascript">
		jQuery(document).ready(function() {
			if (jQuery(".connect-page-tag-accent2 span").html() == ""){
				jQuery(".connect-page-tag-accent2").hide(); 
			}
			jQuery("[id*='promotedlinksheader']").each(function(){
				if (jQuery(this).parent().html().indexOf("The list is empty") > -1){
					jQuery(this).parent().find("td").empty();
				}
			});
			var titleBottom= jQuery("#titleAreaRow").offset().top + jQuery("#titleAreaRow").height();
			var contentTop = jQuery("#contentRow").offset().top;
			if (contentTop < titleBottom) {
				jQuery("#contentRow").css("padding-top","60px");
			}
		});

	</script>
	<PublishingWebControls:EditModePanel runat="server">
		<!-- Styles for edit mode only-->
		<SharePointWebControls:CssRegistration name="<% $SPUrl:~sitecollection/Style Library/~language/Themable/Core Styles/editmode15.css %>"
			After="<% $SPUrl:~sitecollection/Style Library/~language/Themable/Core Styles/pagelayouts15.css %>" runat="server"/>
	</PublishingWebControls:EditModePanel>
	<SharePointWebControls:FieldValue id="PageStylesField" FieldName="HeaderStyleDefinitions" runat="server"/>
</asp:Content>
<asp:Content ContentPlaceholderID="PlaceHolderPageTitle" runat="server">
	<SharePointWebControls:FieldValue id="PageTitle" FieldName="Title" runat="server"/>
</asp:Content>
<asp:Content ContentPlaceholderID="PlaceHolderPageTitleInTitleArea" runat="server">
	<SharePointWebControls:FieldValue FieldName="Title" runat="server"/>
		<div class="connect-page-tag">

			<span class="connect-page-tag-accent1"><Taxonomy:TaxonomyFieldControl FieldName="Organisation" runat="server" ControlMode="Display"/></span><span class="connect-page-tag-accent2"><Taxonomy:TaxonomyFieldControl FieldName="Document_x0020_Function" runat="server" ControlMode="Display"/></span>
		</div>

</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderTitleBreadcrumb" runat="server"> 
	<SharePointWebControls:ListSiteMapPath runat="server" SiteMapProviders="CurrentNavigationSwitchableProvider" RenderCurrentNodeAsLink="false" PathSeparator="" CssClass="s4-breadcrumb" NodeStyle-CssClass="s4-breadcrumbNode" CurrentNodeStyle-CssClass="s4-breadcrumbCurrentNode" RootNodeStyle-CssClass="s4-breadcrumbRootNode" NodeImageOffsetX=0 NodeImageOffsetY=289 NodeImageWidth=16 NodeImageHeight=16 NodeImageUrl="/_layouts/15/images/fgimg.png?rev=23" HideInteriorRootNodes="true" SkipLinkText=""/> </asp:Content>
<asp:Content ContentPlaceholderID="PlaceHolderMain" runat="server">
	<div id="connect-page-info" style="visibility:hidden">
	</div>
	<div class="connect-col-r">
		<div class="s4-wpcell-plain ms-webpartzone-cell ms-webpart-cell-vertical ms-fullWidth">
			<h2 class="ms-webpart-titleText">Related Pages</h2>
			<PublishingWebControls:SummaryLinkFieldControl FieldName="SummaryLinks" runat="server"/>
		</div> 
		<WebPartPages:WebPartZone id="Right" runat="server" title="Column Right"><ZoneTemplate></ZoneTemplate></WebPartPages:WebPartZone>
	
	</div>
	
	<div class="article article-body connect-article-body">

			
			

		<PublishingWebControls:EditModePanel runat="server" CssClass="edit-mode-panel title-edit">
			<SharePointWebControls:TextField runat="server" FieldName="Title"/>
				<Taxonomy:TaxonomyFieldControl FieldName="Organisation" runat="server"/>
				<Taxonomy:TaxonomyFieldControl FieldName="Document_x0020_Function" runat="server"/>
				<Taxonomy:TaxonomyFieldControl FieldName="ClassificationLevel" runat="server"/>
				<SharePointWebControls:TextField FieldName="Document_x0020_Reference" runat="server"/>
				<SharePointWebControls:UserField FieldName="Document_x0020_Owner" runat="server"/>
				<SharePointWebControls:DateTimeField FieldName="Document_x0020_Review_x0020_Date" runat="server"/>
				

		</PublishingWebControls:EditModePanel>
		
		<div class="article-content">
			<PublishingWebControls:RichHtmlField FieldName="PublishingPageContent" HasInitialFocus="True" MinimumEditHeight="400px" runat="server"/>
		</div>
		
		<div>
			<WebPartPages:WebPartZone id="CentreTop" runat="server" title="Top"><ZoneTemplate></ZoneTemplate></WebPartPages:WebPartZone>
		</div>
		<div>
			<div class="connect-col-wp-left">
				<WebPartPages:WebPartZone id="CentreLeft" runat="server" title="Centre Left "><ZoneTemplate></ZoneTemplate></WebPartPages:WebPartZone>
			</div>
			<div class="connect-col-wp-right">
				<WebPartPages:WebPartZone id="CentreRight" runat="server" title="Centre Right "><ZoneTemplate></ZoneTemplate></WebPartPages:WebPartZone>
			</div>
		</div>
		<div class="connect-page-info">
			<span>Rating:
		    <SharePointPortalControls:AverageRatingFieldControl ID="PageRatingControl" FieldName="AverageRating" runat="server"></SharePointPortalControls:AverageRatingFieldControl> 
			</span>
			<span>Owner: 
				<SharePointWebControls:UserField FieldName="PublishingContact" runat="server"></SharePointWebControls:UserField></span>
			<span>Last modified:
				<PublishingWebControls:LastModifiedIndicator runat="server"/>
			</span>
			<span>
				Reference:
				<SharePointWebControls:FieldValue id="_dlc_DocId" FieldName="_dlc_DocId" runat="server"/>
			</span>
		</div>
	</div>
</asp:Content>
