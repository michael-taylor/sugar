<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="Build" ToolsVersion="4.0">
    <PropertyGroup>
        <ProductVersion>3.5</ProductVersion>
        <OutputType>StaticLibrary</OutputType>
        <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
        <AllowLegacyCreate>False</AllowLegacyCreate>
        <Name>Sugar (iOS)</Name>
        <RootNamespace>Sugar</RootNamespace>
        <SDK>iOS</SDK>
        <ProjectGuid>{91B301FC-331E-48A7-803B-4CBE3FFF6ED7}</ProjectGuid>
        <AssemblyName>Sugar</AssemblyName>
        <DefaultUses>Foundation</DefaultUses>
        <DeploymentTargetVersion>6.0</DeploymentTargetVersion>
        <AllowLegacyOutParams>False</AllowLegacyOutParams>
        <CreateHeaderFile>False</CreateHeaderFile>
        <SimulatorArchitectures>x86_64,i386</SimulatorArchitectures>
        <Architecture>arm64,armv7s,armv7</Architecture>
        <CrossPlatform>True</CrossPlatform>
        <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
        <Optimize>False</Optimize>
        <OutputPath>bin\</OutputPath>
        <DefineConstants>DEBUG;TRACE;IOS</DefineConstants>
        <CaptureConsoleOutput>False</CaptureConsoleOutput>
        <StartMode>Project</StartMode>
        <XmlDoc>False</XmlDoc>
        <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
        <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
        <SimulatorArchitectures>i386;x86_64</SimulatorArchitectures>
    </PropertyGroup>
    <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
        <Optimize>True</Optimize>
        <OutputPath>.\bin</OutputPath>
        <GenerateDebugInfo>True</GenerateDebugInfo>
        <EnableAsserts>False</EnableAsserts>
        <CaptureConsoleOutput>False</CaptureConsoleOutput>
        <StartMode>Project</StartMode>
        <XmlDoc>False</XmlDoc>
        <XmlDocWarningLevel>WarningOnPublicMembers</XmlDocWarningLevel>
        <EnableUnmanagedDebugging>False</EnableUnmanagedDebugging>
        <DefineConstants>IOS</DefineConstants>
        <GenerateBitcode>True</GenerateBitcode>
    </PropertyGroup>
    <ItemGroup>
        <Reference Include="Foundation"/>
        <Reference Include="libNougat"/>
        <Reference Include="libxml2"/>
        <Reference Include="rtl"/>
        <Reference Include="UIKit"/>
    </ItemGroup>
    <ItemGroup>
        <Folder Include="Cryptography\"/>
        <Folder Include="Properties\"/>
    </ItemGroup>
    <Import Project="$(MSBuildExtensionsPath)/RemObjects Software/Oxygene/RemObjects.Oxygene.Nougat.targets"/>
    <PropertyGroup>
        <PreBuildEvent/>
    </PropertyGroup>
    <Import Project="Sugar.Shared.projitems" Label="Shared"/>
</Project>