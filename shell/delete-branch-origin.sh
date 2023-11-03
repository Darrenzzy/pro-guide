# 获取远程分支列表
branches=$(git ls-remote --heads -q origin | cut -f 2)

# 循环遍历分支并询问是否删除
for branch in $branches; do
  read -p "要删除远程分支 $branch 吗？ (y/n): " choice
  case $choice in
    y|Y )
      git push origin --delete $branch
      echo "已删除分支 $branch"
      ;;
    n|N )
      echo "未删除分支 $branch"
      ;;
    * )
      echo "无效输入，跳过分支 $branch"
      ;;
  esac
done
